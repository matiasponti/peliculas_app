import 'package:flutter/material.dart';
import 'package:peliculas_app/src/models/pelicula_model.dart';
import 'package:peliculas_app/src/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate {

  String selection = '';

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'spiderman', 'batman', 'frozen', 'daredevil','lord of the rings'
  ];

  final peliculasRecientes = [
    'Spiderman', 'Capitan America', 'Matilda' , 'pinocho'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      ),

    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crear los resultados de busqueda
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(selection),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query) ,
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {

        if (snapshot.hasData) {

          final peliculas = snapshot.data;

          return ListView (
              children: peliculas.map( (pelicula) {
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage( pelicula.getPosterImg()),
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    width: 50.0,
                    fit:BoxFit.contain,
                  ),
                  title: Text(pelicula.title, overflow: TextOverflow.ellipsis),
                  subtitle: Text(pelicula.originalTitle, overflow: TextOverflow.ellipsis,),
                  onTap: () {
                    close(context, null);
                    pelicula.uniqueId= '';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }



}