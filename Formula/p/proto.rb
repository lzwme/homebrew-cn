class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "00b4053527ed12be90077e949cc45ffcaeb5eeaf054fa84e773e5ff11e42d7ea"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "951695dcb1ef54559eafc54ecece2df42d04aa3b855313839ea66dcf6c05f008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e44893059b23198b8c3084082ecada46248f74b7f6f5483484566cbe7172b3df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a45e88016c9f517b62ad66598b05b37a6379364b2a02e1a6024b3b835a096d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe216ba2758b4f9b8c58284a61462f81518a064bc2669b4b168c8e2b12f9b597"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200826e091f6cbc2ec6b8c80f8197937144f2480a170c8b13bbf6d1692052fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e30ebf78c021e94ebf83d59cca719e0bf2efd1e1d089160a5a4c685c39d10ce"
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