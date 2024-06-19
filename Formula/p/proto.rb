class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.37.1.tar.gz"
  sha256 "febcc4355026ec4f2ae660730083595d46ee0ef45b7f8a3d52f788430cb6198f"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27abf2874c31aab5ec1eb2b155f49d832b7a23add283b8244b23ce0df5ba499f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a032b9b4c83973b315f69d2796f7a8062961881b5c623b045e1b100474903113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437926ab6439e416220e02726df059df2d9b4e223320d7b7d386dd8e431ff09e"
    sha256 cellar: :any_skip_relocation, sonoma:         "731a0cb53901b5e88e50858784a997b85f62a0dacd37ea8cd6694ecfa0d5d26a"
    sha256 cellar: :any_skip_relocation, ventura:        "6d84a7ebaf58d65f6b4e6a89604cb1b22add6b64703ec4228b3d2f21254f3eaf"
    sha256 cellar: :any_skip_relocation, monterey:       "42c6f4849d7f1082880ac8562d4cdea7eab2f072f3480b22e710e77a11517975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92370852f300045f293406392a1d7c5eb7d6735f0eeee4f8ca2aac6c2846cded"
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