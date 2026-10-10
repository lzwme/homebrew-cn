class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://ghfast.top/https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.6.0.tar.gz"
  sha256 "65c3a9825c8596fddefc17459d85f05b8f0bf5f19a056ac507582d9c42389e7f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a633a54cd6e7976e028188709fd5b95266049e86644d0ef79674bc2cac1aac39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "198d230d0ff96cc999a44bd9a1f90deb7e420e719dc83299a5e43d32c3562bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcf4ce5b80a5f29e62015e7e546fd888ce7c6e971c987d957d218a4054ac2bcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "746e8ad5c089b82c65867c3eee922ddd786afaffe8164aaf9a423121488d598a"
    sha256 cellar: :any,                 x86_64_linux:      "a5ae780d75cebe32c437b9eab4f14eb35be82774d991bb93ac38a723036c9b41"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end