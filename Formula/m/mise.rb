class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https:mise.jdx.dev"
  url "https:github.comjdxmisearchiverefstagsv2025.4.6.tar.gz"
  sha256 "2bb4635020c7856ad2905c2fa7c4b1fc4f633615b2e544ae67852124034369b8"
  license "MIT"
  head "https:github.comjdxmise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d61b3864c88b33902ec5fe413be7d73b93d307b276929518ef28af14be83baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fe953032a2641e2b39edaffebc89cd201e9d27a45c65c063fe83bad92d43c14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eaeb101e70d1d0ec23b7cf582121688417c6e9503b6d951ef4cc2957bb94ccad"
    sha256 cellar: :any_skip_relocation, sonoma:        "31ec2d3d8df7ce3d62bffd2953ebbeeb1bdc183a831754effaeb95b260550ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "22f5c881f75407487fd7430452829800b4cdc19cf6cc294e37cdfdf4a37daef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12ee563750a4c8ad7149a73c167100fdbb782f42c611ae14b6226d70782c4745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f0a84617fd3b13dbccea1c04e58ee10fab365ff5849dcc35134c60e053238da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "manman1mise.1"
    generate_completions_from_executable(bin"mise", "completion")
    lib.mkpath
    touch lib".disable-self-update"
    (share"fish""vendor_conf.d""mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}mise activate fish | source
      end
    FISH
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin"mise", "settings", "set", "experimental", "true"
    system bin"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}mise exec -- go version")
  end
end