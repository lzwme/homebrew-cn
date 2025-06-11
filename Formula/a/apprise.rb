class Apprise < Formula
  include Language::Python::Virtualenv

  desc "Send notifications from the command-line to popular notification services"
  homepage "https://pypi.org/project/apprise/"
  url "https://files.pythonhosted.org/packages/f8/1e/fe19c88c3e1ff96f4ea757bae9f6350060ac28be523507053347aa5d67db/apprise-1.9.3.tar.gz"
  sha256 "f583667ea35b8899cd46318c6cb26f0faf6a4605b119174c2523a012590c65a6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "efca83e33402cd9c97a47bc12239af471f75226c7e607d9cf9f545dc142469e8"
    sha256 cellar: :any,                 arm64_sonoma:  "7f839ea7e876f169d2681fd8b8929c3dea64f28670d4f6ac1efd1b9d5fde9f39"
    sha256 cellar: :any,                 arm64_ventura: "3578cdef5e6ee0d226c1ee22999a28d22c9e83e2ca57684ed4b025e0c7fa39f2"
    sha256 cellar: :any,                 sonoma:        "479fdb08b2da41f4815691c88ad54d09d42337e2d095d66bcdd37786e28cd36a"
    sha256 cellar: :any,                 ventura:       "1a5047e13d554eba586031bc1d278bc5f641e77d5f3b5f074937f908b05c1940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6439b294a7c9e49ceddfdca012bdcf9f6bd532c5de6b962818221666ebcd7ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c97c36594a2066ca1debd1ab23ab3ef0417adf9250a46b6380383b5ccd2c98"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2f/15/222b423b0b88689c266d9eac4e61396fe2cc53464459d6a37618ac863b24/markdown-3.8.tar.gz"
    sha256 "7df81e63f0df5c4b24b7d156eb81e4690595239b7d70937d0409f1b0de319c6f"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"apprise", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Setup a custom notifier that can be passed in as a plugin
    file = testpath/"brewtest_notifier.py"
    file.write <<~PYTHON
      from apprise.decorators import notify

      @notify(on="brewtest")
      def my_wrapper(body, title, *args, **kwargs):
        # A simple test - print to screen
        print("{}: {}".format(title, body))
    PYTHON

    charset = Array("A".."Z") + Array("a".."z") + Array(0..9)
    title = charset.sample(32).join
    body = charset.sample(256).join

    # Run the custom notifier and make sure the output matches the expected value
    assert_match "#{title}: #{body}",
      shell_output("#{bin}/apprise -P \"#{file}\" -t \"#{title}\" -b \"#{body}\" \"brewtest://\" 2>&1")
  end
end