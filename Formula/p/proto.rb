class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.1.tar.gz"
  sha256 "900b34bbe42d89c90d3c04576c547f8bc69a26a7c05f19c05a9b174188931bd5"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c972ccf722c9bbc88eea999d8465c44cef98617d920091592ba80a9d282e39cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71efed0727ed0e758ae11c212e9427adac023268c823d48fc49b6c4565476974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adec14fc3aea7e0d97db039261480c22fed99f3fbdb3e5b07ab70bff20ced711"
    sha256 cellar: :any_skip_relocation, sonoma:        "91f81494a6c8675b357d0c0ea9c52567e9415f8080baa63919a6b25a9d1c4ca0"
    sha256 cellar: :any_skip_relocation, ventura:       "d1e622d898a0723911a77020e248c785ae8b67e2b108c0b61a5d02d7e750e882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c29621d81602b779a8280edb054970d1fc62d252f33dc3ee6a7ca75eda0e68b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end