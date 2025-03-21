class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.6.tar.gz"
  sha256 "667550768cd6602328908bf91f12a9e83286df95ab4fdefc3ada57ceb0d17e5c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a22089a53b77afad63f9f0c77ab3d36324ba2f5f82836e6b3409d34933d55b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd055fd8d28991f1df8de18756a51473914d219eb61bb194602e44adae43846"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fb01afe7cc4fdb98373788dacd810be76848de99508b96c1d4f9e15a2caf0f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2f11e25ebde48291225188d468068ee11e267d92c4c6b02a812201c1cb79a18"
    sha256 cellar: :any_skip_relocation, ventura:       "665797ecd319dde970f5292626da7c6eb0257465b87dc5f8fe3f10ecbb383ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cccf4e9071c846b26e8651b43eb80339bdb09e654f568398d77ce7a7d8df2ae"
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