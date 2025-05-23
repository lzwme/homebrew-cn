class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.49.3.tar.gz"
  sha256 "4c6dccd39bc0960b3262d49808e7fcaef01a02d22ac1c4851476641055bd69e6"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "819b55743464bbd5a95c4e82e36ca27551505b0b61c40c657a25169437e31ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad378aa7c00b59ce3b0645719757affa7685d277502f5b2b244c7aa9fc6aadb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67e07810919934391fec6ec7cfff57bc532e1c33fa9aec21a9bfe979f7890ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac06cb0870d1dd29450f696e029b5f1dba5eee01938743fc00c50e5b5e76635"
    sha256 cellar: :any_skip_relocation, ventura:       "6167aad1428d6e4894ed1209e907dd6b9be92caf98b0f310e08d40454c46401a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ba688d628fb32411cf46c7611dd186645e4537cb9b57162365b42d9c99faeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7967d490815a021769acaa068c766f1d7640d14b804fe5a0921998fdfaa8bc05"
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