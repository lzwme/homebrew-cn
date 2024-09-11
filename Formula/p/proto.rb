class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.0.tar.gz"
  sha256 "91aad7b9706c36f33499b4a70ca04bc01008781958b0cac3cce52fcc772d753c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "618340f020f47e741b8c37ce4a522b24b2417524ca003723718db3cfd8761e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa77b9d939f60950da3c8178585a7ef152ceff99df0267a3ad8276b606765e8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96c38925a3fc296615be8abf8aea5cca8aeb76a4198fef9122f460e08e26c22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6bd66584fe440c8d6f03239effa78e24238aaf038a96447daf801455ac2e7ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "a74293d47c1e089e2461c303e8c7d3e927bff243336135b5b52b03d85285d725"
    sha256 cellar: :any_skip_relocation, ventura:        "bc82a5dbde52b1a908f24015533b52f8e938f86cf8a0547475d749c777a18d49"
    sha256 cellar: :any_skip_relocation, monterey:       "dec17a203640700b79826545b24a2897b8af6468f53667568a0e542a8a267072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "386779b7c4c4747ce949dc30c71dd8632f638b386742bb407ba6676ad147310e"
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