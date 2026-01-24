class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "738284375ef738961e12fd41df2df541615f5452888236f7fc2a40fe19c4ea95"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f83fd22df06676cc5ddd6d10e223ce55fdb76f5ad0793cbef02bb84501023a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1343b757f09f8ed8785f02a2821464410bcaf7e0e101a928aa6dcfa19175f409"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93dbb49cecbd92339264fc03edd9a186e40eb68995687d7f559055baedc2940"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8be9f548f067dd824c10d4c14394cb53b5bfe646c6224e3e88c9f14e4d8156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d91cecc528e0a61787436bf60455ddbb93b1b3f458c5b28d559811bf14265090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b210f5295af7bda961ced44592de0ca2d1a0e54565fbfaa99561ba6e3476c232"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end