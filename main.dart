import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      home: Calculadora(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _display = '';
  String _resultado = '';

  void _adicionarValor(String valor) {
    setState(() {
      _display += valor;
    });
  }

  void _limpar() {
    setState(() {
      _display = '';
      _resultado = '';
    });
  }

  void _calcularResultado() {
    try {
      String expressao = _display.replaceAll('x', '*').replaceAll('÷', '/');
      final resultado = _avaliar(expressao);
      setState(() {
        _resultado = ' = $resultado';
      });
    } catch (e) {
      setState(() {
        _resultado = 'Erro';
      });
    }
  }

  double _avaliar(String expressao) {
    List<String> tokens = expressao.split(RegExp(r'([+\-*/])')).map((e) => e.trim()).toList();
    List<String> operacoes = RegExp(r'[+\-*/]').allMatches(expressao).map((e) => e.group(0)!).toList();

    List<double> numeros = tokens.map((e) => double.tryParse(e) ?? 0.0).toList();

    // Multiplicação e divisão primeiro
    for (int i = 0; i < operacoes.length; i++) {
      if (operacoes[i] == '*' || operacoes[i] == '/') {
        double resultado;
        if (operacoes[i] == '*') {
          resultado = numeros[i] * numeros[i + 1];
        } else {
          resultado = numeros[i] / numeros[i + 1];
        }
        numeros[i] = resultado;
        numeros.removeAt(i + 1);
        operacoes.removeAt(i);
        i--;
      }
    }

    // Depois adição e subtração
    double resultado = numeros[0];
    for (int i = 0; i < operacoes.length; i++) {
      if (operacoes[i] == '+') {
        resultado += numeros[i + 1];
      } else if (operacoes[i] == '-') {
        resultado -= numeros[i + 1];
      }
    }

    return resultado;
  }

  Widget _criarBotao(String texto, {Color cor = const Color(0xFFFF9500), Color textoCor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: cor,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () {
            if (texto == 'C') {
              _limpar();
            } else if (texto == '=') {
              _calcularResultado();
            } else {
              _adicionarValor(texto);
            }
          },
          child: Text(
            texto,
            style: TextStyle(fontSize: 24, color: textoCor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Calculadora', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Text(
                '$_display$_resultado',
                style: TextStyle(fontSize: 48, color: Colors.white),
                maxLines: 2,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _criarBotao('7'),
                  _criarBotao('8'),
                  _criarBotao('9'),
                  _criarBotao('÷'),
                ],
              ),
              Row(
                children: [
                  _criarBotao('4'),
                  _criarBotao('5'),
                  _criarBotao('6'),
                  _criarBotao('x'),
                ],
              ),
              Row(
                children: [
                  _criarBotao('1'),
                  _criarBotao('2'),
                  _criarBotao('3'),
                  _criarBotao('-'),
                ],
              ),
              Row(
                children: [
                  _criarBotao('0'),
                  _criarBotao('C', cor: Colors.grey, textoCor: Colors.black),
                  _criarBotao('=', cor: Colors.green),
                  _criarBotao('+'),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Desenvolvido por L. Gabriel V. Gomes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
