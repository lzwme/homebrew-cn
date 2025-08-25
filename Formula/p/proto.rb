class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "21ed3d16b9acfa72eae382d38ea168f20fb78b744b475bc98cd75bf14f1d6c25"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b831fea3609a3e2757e1ca7da53a0bf5dcea0d49b4cc3fb015ea53a250524d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b92a35bac38055b81aab7631c70911bb7bb555e1fd79a37bfffeafcc76ff8298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73bec8823723d8bc6c767bfbb061db4dadb33d2b05f4ca36304293f7f16fd9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a3ca173daddc4c00c411e3c554de5effb39bbe8f5942b34b70632aa073e7293"
    sha256 cellar: :any_skip_relocation, ventura:       "d83c7ed532788db088b3fafdab913a0976a9fb26499f891d5f773f0b66e7e316"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3aab606e601f8cb3fb97fa1d996b5f142f3d64aa71ce5497f4ca5dc574729bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37757350667ae774c6c57a03ea42ce49ee59a937040d28969a3db6217e9086a5"
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