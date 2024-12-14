class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.43.2.tar.gz"
  sha256 "31645141e3e1b7dc11653237bf6a2cb7ff79af61d9bea2df7c729527f456b273"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d02194ebe18caf168662d0062fc2cd602b254318d0293afc75be1128107865"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd7e119cbdd505c4e6924c07ff2d54fe409dbe901523b84b1c95d66cddbda1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ebb6b33216136694f0a450581d7df993c3585f5375a91cca02de5a74413e159"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e560faa406b60d2490a02808c651c1726e585c346e1d371482fed02c37ed3d3"
    sha256 cellar: :any_skip_relocation, ventura:       "e93b9045d57a1992f98adc7b603fb114fd4736349ef15f2ac8115cc5968ff3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585fc24c661c71dbe68e88370d2f754fc58033e2ddce1bfb92c30d53a4829369"
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