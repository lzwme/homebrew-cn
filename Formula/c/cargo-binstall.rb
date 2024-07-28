class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.8.0.tar.gz"
  sha256 "326f41290de3e0d5f583fa555720ce31d65d91434b9521fcbbbff3bbd692539a"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efb27776091b28870d654bd67574e82139f80fc6a93b4520dc6c9a70d0eadd28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bfe80de6c7ba2692be917efc74ca9416c998376e0ec6a50706553f87841986f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db3224108e2841022bbfb2ae086949588f7211e3c8c0bfc7d7e9d06c85ebcee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "da58095974825ce2e0e0254044f8433d8796d5b67e1b86ba05b8f69e1ef2ab8c"
    sha256 cellar: :any_skip_relocation, ventura:        "2552cb40904c4b913a1e345c9a98c9cb0cd406710d1e5988f5390cb0829e8a96"
    sha256 cellar: :any_skip_relocation, monterey:       "f3278daca687ddfeff959cbe48ee1e2f1c6d491dc2c07b44296c0aaf9b5bd6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa11df4201f31ffa3e407690ccb07d890954b26ab29eb4726f055852759a4592"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end