class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "9981deb6cdd43491710bbf2efb6cc33985b55b10609afe647c52cc5f214c0e79"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a800ae2335c0569c981e507a0bc8c432bef80cdb82f807bc53b31ccf1845229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc2d05e363087f38c880d938415ac05d62aa84d19ac98f7e89c6742ee4cb9e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bad5bcc350e00bcaab60aede8d573d0ffb5eb072397052f303766a5b4f736b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb7fe40115983797c3b15710f605f9a053872056ca6621732d85e6ec8ff58c9"
    sha256 cellar: :any_skip_relocation, ventura:       "fd393f1d2cbf58b1a3436b2f175e9217c5782b204b37362952c3de8aa23772e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7281a43b99164031dd0cddf52659413bcbe86111cb9ee5c191b42fe1ea8c3e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69accafb2ac02efe6c3ca346f781d8f0b63e451a0b36b97234b8b4678170871"
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