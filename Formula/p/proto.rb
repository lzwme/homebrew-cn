class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.7.tar.gz"
  sha256 "6346177d6f55409d30a38d8fba0e494801bffbeb7644680f058c6a91132685ea"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4feb30fa1a084ee081871d5a15d9b97e1aeb0082a325217d5b6f4d6d981b9105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0c8cc53e3b147d7a813c2769f9f564da1849f9524968bce20caa5914e0257d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "053a192122a6fffff24b9509700d6a11597bbe6064e8fc424f093471b40ce2d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "625fcdc13ddf92702391975fef96e725d2220c37eb68240c238a14fc72ccfb92"
    sha256 cellar: :any_skip_relocation, ventura:       "ba6284f10a2649195fb4325ef09817c544d435df9821ab42af6a46bb6f547756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0640a74acee989f1f8615539ea965821dd136a7797407b163e8a0de271904276"
  end

  depends_on "pkg-config" => :build
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