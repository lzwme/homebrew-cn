class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://ghproxy.com/https://github.com/dlang/dub/archive/v1.33.1.tar.gz"
  sha256 "60759c8f1d8cf81d5dfbffc7d76adc9855c5f2eeed1525a0fd523d0e79fcc88f"
  license "MIT"
  version_scheme 1
  head "https://github.com/dlang/dub.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdc1c5eba01216d1b2ee7253c0ce5c9c839875d828cab1f6402a01c13ebc6938"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94b3ff9708ac2b754299c94077249873a1daf87005972c17e046ad385c9d65f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e2fd829ed3c3ad4599f93fa8f64b8b4b5f9df9ecb8bdc537bea6dd6dbd0927"
    sha256 cellar: :any_skip_relocation, ventura:        "5ef53b57a0e4e41a11e22e9f925e7fba10acb5e6bf70807e701e58de147c8031"
    sha256 cellar: :any_skip_relocation, monterey:       "55c94be61ba6c2d1ea0d17f5717127af031f44cc68cb1b907225d0e133823d5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "67edd1d5d02eda484128c4870f833eee349aaf51e64f4f1f55c38201d76fb978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97030e9b840fc6a08321c0a0e84dc008634a8d850ae45dc324b082d080d00298"
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