class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
  sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ceefae3057f437bbdbd2305549d79634f8e77d4cbe7a913164fba21750ede55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43d4fbc8d4d3fd99b68b7235231e1f80fe39623630a0018c6867fcf0d4f81eba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39bd940a022253973f0c223980d543dad7541246164f4f14e28ae7141ac2b776"
    sha256 cellar: :any_skip_relocation, sonoma:         "84d9894c8557213e0185cd1b140483d2c2998cf8fb6d90cdf8747e888aebfdaa"
    sha256 cellar: :any_skip_relocation, ventura:        "73c56fa5973ac2b70eebd4af17973264b9042714d2b2e2a8a827a2d5ea22f55d"
    sha256 cellar: :any_skip_relocation, monterey:       "618984fe3980ddab648a4a9ae5346c2182c41c5e500eaa2c9fe85aafb1f516da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38832fdcb17b88d1284bcc333e491c3be099bfa0596230dde0f0b9d819ef3f58"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end