class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://ghproxy.com/https://github.com/bobthecow/psysh/releases/download/v0.11.14/psysh-v0.11.14.tar.gz"
  sha256 "6aa4379ecb8c5e256b7e4bc7b770a82d07b743ab22929327a3b78141a6567ca3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591a4236d91f234e395d5127535be0e23e7848381a6f69f6ade819d639eb7267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "591a4236d91f234e395d5127535be0e23e7848381a6f69f6ade819d639eb7267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "591a4236d91f234e395d5127535be0e23e7848381a6f69f6ade819d639eb7267"
    sha256 cellar: :any_skip_relocation, ventura:        "713b489e7f5ffdc48329064c21269aa3da9ce0efbbf9879be167917847cc376b"
    sha256 cellar: :any_skip_relocation, monterey:       "713b489e7f5ffdc48329064c21269aa3da9ce0efbbf9879be167917847cc376b"
    sha256 cellar: :any_skip_relocation, big_sur:        "713b489e7f5ffdc48329064c21269aa3da9ce0efbbf9879be167917847cc376b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591a4236d91f234e395d5127535be0e23e7848381a6f69f6ade819d639eb7267"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end