class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.39.4.tar.gz"
  sha256 "20fdbccd2f54bffa4d9ff485764b6a49e1b64253cddf8da8bcc0d310206b05ae"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "356ef2d4955ab0461e91f7f576be9fae9df988de79f0803bda82208dffe03bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c90a14ade4070cc4d201fd2bad0e8f37d362a5a341f16fc86a5bced319094e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f1b3ecfed585741557e55646f920aeda0641e7dcc7e9a6e81a15f9ee3bf8d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "31a7dda4cbf30b1220e7b9b21ed4dfbb8a9c055dac829e403d3c9c56c7170563"
    sha256 cellar: :any_skip_relocation, ventura:        "4e14b2837d6ccfe268d9d70bfe4898e77894d6b57b26c6cc0dae9e943bafd8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "02da699b7b224aeede2dd5e550254998e819ef9a57f347de9f70a8ba3511760f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c59836c4fd6bb1d8c2cf29110c108d51943e5606971931adb6c8cd485aa92e5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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