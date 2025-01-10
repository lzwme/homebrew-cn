class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.5.tar.gz"
  sha256 "b30940a09bd2bb26ec90927556ce0d284e9383487d3a70266d7e44a6833b63d2"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6caf0326184ece75c0be4be7b3f6532a4e4dca0dd1603e4b99dbccf397dbe621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995236a0cc7858acbbfc81a2061bea386fac09ad7d77f4367d9c349ce2609a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfd55dcdbbbd80f5b20cc14c209eed684e344ebee4c1caf1e85e3457ffb58883"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4445d25631e40e0e37871463ad643863ca056c02ff81f1b3bd53f3bae11ba8"
    sha256 cellar: :any_skip_relocation, ventura:       "95d203053076a01ab68fb91b35933f8be327e374d9e523a8130ec2478074a28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01849fd47470e4df6e26e6e7a3095ed8ab54288bd9600afbe3e0a0d2c5d87295"
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