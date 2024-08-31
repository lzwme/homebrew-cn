class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.40.4.tar.gz"
  sha256 "f6bccb7e7896aee0f16e233bd950789052974e16df1aec4e5085224d0ac83a8e"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e318f37c92ddf307bc52c20d6c6f794bd30349ccaf1e1ab1fedb3ab50f0ffa1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7539b3a56e2702356d5b964f3382f159cd2597790c93b1ebca04f93856ec3de7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25154608f09ada6cb858b7d5c0d9c719df375b2db32e9ebf610e2c14839e99cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf78ac933cff51052570ad21d111336df191438ce9ffa29e33cc81e46a04ad13"
    sha256 cellar: :any_skip_relocation, ventura:        "3a9a5bf37c10ac2726b79493ec6fe7596c750feb190bac977ea4368f34385ecb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d61425d277b17773ee726f343e4419d23efb66761049bc1ce2107028221d926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "111902e80e6c14402775eededc9e4747321db38437399e396fedcb46d5f36250"
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