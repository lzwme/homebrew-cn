class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.38.3.tar.gz"
  sha256 "e9a3bbc46de355c451136a05b150a3eab3c1986493904727f6a4f00da705fe02"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a59bddf80c21ae62028734f1185589f6a04005e3d1bbfe52a30829655539c311"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa9b45bb95dd4405abaf89a055edcc23fbba0d605046ee2e6988fe2cbf2aad72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "086fdfdb5617255c976bbb8ccf744c545908c98177409ae178b8539a68d85011"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f60991a71a6f4f47a8df1bf8da5433dee2c5b41c9e3b07a79403f9b383646a9"
    sha256 cellar: :any_skip_relocation, ventura:        "eb5f868eaf3b9fc91c5e1c6731cc6483caa2f4081e909eab832399213810a2bf"
    sha256 cellar: :any_skip_relocation, monterey:       "eecc6f40afe787c198cfda753185c3b55c2a26820ab10677bfdc53a72009db7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d740cd6dab46306fdf292bd3e49448134e27d97a11b85801ee41c6d2e9f7635"
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