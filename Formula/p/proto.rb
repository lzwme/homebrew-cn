class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.4.tar.gz"
  sha256 "5a55cd763f8782201c259c6009468178605586d671f13e3e838a96d03f595e7f"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db340b2782fdf5151798c41d8cc4556137c66a001bd46baee55a55034e0b5b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad3bc342ecee6c9172eb816efcb1b08519877ff126f4c1749705e8548f27e21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22071d859c5a8f318e68e886a75b9c18ae263ad62cdec478a3b68903ecd0dd45"
    sha256 cellar: :any_skip_relocation, sonoma:        "438ac241092781d54dd00dab5438cabc350ee494b761c7e980ac97445ddaf087"
    sha256 cellar: :any_skip_relocation, ventura:       "0f0b3e2bc27f1d735ce02c4863568a130579a97da1c9c5bb506d8abf9e43f1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32fae4d7c839094489a0be0f353c70171866aa641f19ba099cf316c45c8a691c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fea07f4f80a3733fb7aedff89a3801be8138aa11c9928268504aaa3efb4a39f"
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