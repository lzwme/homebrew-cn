class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.4.tar.gz"
  sha256 "51ad93feebc68d2511ec5589eb5a09d5956b36d0593d4a304f9303850b0deb28"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2187b5dbaa027f5c17877216919a71b8a1e0e95a7d78e72a1580baac68356ba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcfdd6ba407872ec9ae5ae15754bb560c35bfa177161f7651a05398411a277ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c10cf562444f18729c48fd07189bf18b0c7cffeb89fa118d9918ca9d103d42eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "947c73a541c850b03f769dbaf34299540a075f1de8719b04ea48af5a5e4c1b2e"
    sha256 cellar: :any_skip_relocation, ventura:       "57db13bc044da4b3994db97b36d9eb07e436da0d587010ecda26b6a7c7af6478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9d6b4f39b4caa17d38303bc150cd8b45cbb34404ac1456b6b7c65a4a5285e2"
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