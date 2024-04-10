class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.34.2.tar.gz"
  sha256 "ae44cd8baf04d9960f31b7afa2ded8233c7d3efe8467129698cd458dafad19b2"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acd78f9400db24a41d20c8d4c4b478da2e54c855a7eb08ac4953cbb8f3ea6fad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "307c5d10528b3e7ea814aeddcbac7ce884ca61ed5cbb91c1f8f95f51301b575f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24af1be6a8265ee8187deab8e0d91e72c68b905ba39076fdc2c1cb1e66e7abfb"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e44dffc893f4007d7f322d0d1957f1d110105f17be2bd6c553a1e52cfeb11a"
    sha256 cellar: :any_skip_relocation, ventura:        "e679cf0514f09759c88ffd8bc35a6a0d1f57a58a8fb593ed1b66714b6ff5e8ee"
    sha256 cellar: :any_skip_relocation, monterey:       "84e5af0271471f8df264e93da4de6aa67636348edd0e6a97bca5b409e8ffc955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b846e52dd4c744a4d88da9871560aa01d58237bb446f387175a092ebf73fb87a"
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