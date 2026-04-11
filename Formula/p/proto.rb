class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "fa614385f4dfb9cf8151a41e34e02d90a537010a9ed591731875197fcae7ab42"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcdd48b7062b88667e95807bfaab9d0a19e727a036384e663b80fdaa66431fd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f815817b8df43194ce79aaf1c1419d48e694031d6cac6886188168ae79f07feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e43b02258e248ce63adc72f2d40992ed0e9efd9161641955d3ab69add6e37f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e926c9ffd0eefdc951afb502b279d321d680cc090b3303f263ceb34721ed0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5faf9ba917c5eac698e17eef41ecc53c514d838d8f19440371f33b7b903e2324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c79b3fca5cc8ab5ae51a463a30e69139d2da79064e6a50a92f2f2c17845ecaa"
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