class PythonJson5 < Formula
  desc "Python implementation of the JSON5 data format"
  homepage "https://github.com/dpranke/pyjson5"
  url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
  sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d314eb13631172ef72b149457a61277f1ac0096aecc9d63d74a0fa70541687ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e9e91f835dd1a5a37528001672c0c40fb1214f298b9cc3427baa14381cbe92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de829ddddce69301eb29800853f999141db8303d43919f41ef80273648be7f91"
    sha256 cellar: :any_skip_relocation, sonoma:         "af7008b52157d927a1c782511513afc76bbd0edacf822e91234fad27bb6a3bdb"
    sha256 cellar: :any_skip_relocation, ventura:        "0e512f9c303a9d9d325fed53c9965ccc2372ed45356bff182e2cabcd9783dac7"
    sha256 cellar: :any_skip_relocation, monterey:       "bcf69256b9bc30cfc134938cb61a8e9645567b0194f9017fe88c1cb82fc0611a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "264153cc4f88b5683efab346167780eec6a110489a821bbd612f8b842a46eafa"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run `pyjson5`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import json5"
    end

    (testpath/"test.json5").write <<~EOS
      {
          foo: 'bar',
          while: true,

          this: 'is a \
      multi-line string',

          // this is an inline comment
          here: 'is another', // inline comment

          /* this is a block comment
            that continues on another line */

          hex: 0xDEADbeef,
          half: .5,
          delta: +10,
          to: Infinity,   // and beyond!

          finally: 'a trailing comma',
          oh: [
              "we shouldn't forget",
              'arrays can have',
              'trailing commas too',
          ],
      }
    EOS

    output = shell_output("#{bin}/pyjson5 #{testpath}/test.json5")
    assert_equal <<~EOS, output
      {
          foo: "bar",
          "while": true,
          "this": "is a multi-line string",
          here: "is another",
          hex: 3735928559,
          half: 0.5,
          delta: 10,
          to: Infinity,
          "finally": "a trailing comma",
          oh: [
              "we shouldn't forget",
              "arrays can have",
              "trailing commas too",
          ],
      }
    EOS

    assert_match version.to_s, shell_output("#{bin}/pyjson5 --version")
  end
end