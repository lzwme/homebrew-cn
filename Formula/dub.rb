class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://ghproxy.com/https://github.com/dlang/dub/archive/v1.32.1.tar.gz"
  sha256 "cad53d96230d7bccd886c827d8b89ba136479ffa1a504ecd17f960c2ea50ee45"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "672641f2d3fcdafc06c00db117a9ea3c87eb5a29163c2b76c98adeb4f1a43ad9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f681eb1fad923782b8092e2fc9cb733d60a18a84d722b5377c2f48a18b577e28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4f3cc6cb4635fac45c4b4b9d04d4c2b60918d48174c7a2b8c0646b9d37737db"
    sha256 cellar: :any_skip_relocation, ventura:        "eac4bd8f6a5b3527327c59d8e2caff28c63f1a4c6debc29698bf3070c081e84b"
    sha256 cellar: :any_skip_relocation, monterey:       "d72c6c55213676ca9bc6f3342d8202aca5dde6d01c41c0a481d515e9bfb273d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e95b3ea622cba0d50822971b5b15965b1d90b9e98a7e9243af577e4a9be08c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c47e79d72612c9b2914484a0cb34438bb9d4b64be73c2a01b49b68327a80620"
  end

  depends_on "ldc" => [:build, :test]
  depends_on "pkg-config"

  uses_from_macos "curl"

  def install
    ENV["GITVER"] = version.to_s
    system "ldc2", "-run", "./build.d"
    system "bin/dub", "scripts/man/gen_man.d"
    bin.install "bin/dub"
    man1.install Dir["scripts/man/*.1"]

    bash_completion.install "scripts/bash-completion/dub.bash" => "dub"
    zsh_completion.install "scripts/zsh-completion/_dub"
    fish_completion.install "scripts/fish-completion/dub.fish"
  end

  test do
    assert_match "DUB version #{version}", shell_output("#{bin}/dub --version")

    (testpath/"dub.json").write <<~EOS
      {
        "name": "brewtest",
        "description": "A simple D application"
      }
    EOS
    (testpath/"source/app.d").write <<~EOS
      import std.stdio;
      void main() { writeln("Hello, world!"); }
    EOS
    system "#{bin}/dub", "build", "--compiler=#{Formula["ldc"].opt_bin}/ldc2"
    assert_equal "Hello, world!", shell_output("#{testpath}/brewtest").chomp
  end
end