import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        ListTile(title:Center(child:Text("Termos de uso e Política de privacidade do aplicativo", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,))),
        Tile("Ao realizar seu cadastro, o gerente terá acesso a 30 dias gratis para avaliação do produto sem compromisso com a AppSideInc ou quaisquer outras partes por trás do aplicativo. Após excedido os 30 dias de avaliação, o gerente poderá, por vontade própria, parar de fazer uso do aplicativo sem nenhum pagamento de taxa pelo período de avaliação!"),
        Tile("Em caso deinteresse em continuar a utilização, o gerente poderá fazer o pagamento da assinatura mensal no momento que desejar!"),
        Tile("- O gerente poderá em qualquer momento para de utilizar o app apenas parando de pagar a assinatura, tendo assim seu acesso e de seus funcionários limitados pelo aplicativo"),
        Tile("- Tendo retornado ao gerente cadastrado o interesse pelo aplicativo, poderá simplesmente pagar sua assinatura mensal disponível na aba de Pagamento do aplicativo, e após pagamento conluído, terá de volta acesso total referente a o plano contratado pelo mesmo!"),
        Tile("- A AppSide se restringe apenas ao uso do CPF, nome completo e email do cliente contratante para controle e identificação de usuários contra fraude nos sistemas de avaliação gratuita do aplicativo"),
        Tile("- Todos os dados os dados coletados não serão usados para nada além de identificação pelo próprio aplicativo"),
        
        Tile(""),
        Tile("Pagamentos", style: TextStyle(fontSize: 20)),
        Tile("Todos os pagamentos do aplicativo são feitos externamente pela plataforma MercadoPago, não nos responsabilizamos por dados ou informações passadas externamente ao MercadoPago para realizar os pagamentos"),
        Tile("Atenção, não enviamos emails de cobrança ou qualquer outra forma de cobrança que não parta internamente do aplicativo, salvo interações via suporte"),
        Tile("As formas de pagamento incluem conta Mercado Pago, boleto e cartões de crédito(verificar disponibilidade de bandeiras de cartões aceitas pela plataforma Mercado Pago)"),

        Tile(""),
        Tile("Planos"),
        Tile("Todos os nossos planos podem sofrer alterações mediante aviso prévio por parte da AppSide, tendo o cliente direito de cancelar o serviço caso não esteja de acordo com novo valor! O cliente ainda tem direito de uso do sistema até o fim de vigência do pagamento mensal atual!"),
        Tile("O cliente ainda poderá escolher entre mudar de plano sempre que o solicitar, qualquer alteração entre planos só terá efeito no fim da vigência do pagamento mensal atual"),
        
      ],),
    );
  }
}

Widget Tile(text, {style}){
  return  ListTile(title: Center(child:Text(text, style: style!=null?style:TextStyle(),)),);
}
