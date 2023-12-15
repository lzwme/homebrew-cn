class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.26.tar.gz"
  sha256 "cdcc2bb0fee70c3e42efa3233c6c3ed87e3a733f6a0d42660da20a5028c0ce25"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f33ffb9d8e9ca7e1efe10fb87bf4adb2c326dc23490f5235969c4ba4a35c1d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4e57a46ea8def8606f155f66a065115ec2408c0f065da2746816fda2f270e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921ed6ddebb26864f89f20a0046308599516417a06e94036f98efae43fa60773"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e36d4dc016706c1ef62b5fac0d5e3a848980bb9bbec2dfdf55e3e20645634da"
    sha256 cellar: :any_skip_relocation, ventura:        "408e0af758464ed4916c9e36b4e889a43430ea7927f2efd16b896f1da2801fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "889a7adafa42b408c0e82498ac84a796a97d0ae6cb8306087ec36662d5cc463b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d490ad8aa3ff981886d7d71576a589723c359290c56e52f3556d011228685182"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{bin}/rtx activate fish | source
      end
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end