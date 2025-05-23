class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https:superfile.netlify.app"
  url "https:github.comyorukotsuperfilearchiverefstagsv1.3.0.tar.gz"
  sha256 "77fc02ce0ef406fd2e9b42e0746f2282a85b4a148316d274bef3dc6c933127a5"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9bf941855f2d74f09fcaa6af276a709ccb9c39cfab7bdb16ce179ba7c12530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc2caa033e3e0e1f34ea998026d3d8afcb79c7095324cb5bad0e643b1d3cc311"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a077b359e55c9289d666ea3d542cfcd75b3727e105cf37aa87dd7b4bb69a74f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "faa38a51b70307bb8a3aaf177c883fecf99906233e4ccdeca55f2e596e83f532"
    sha256 cellar: :any_skip_relocation, ventura:       "c1467bc9173693ed0730245fcf3918cef4477220cd6387fd4f24e4d626d79ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab94c621e8c6ed3ed3397f0799d314ee4d769a29ae5e2ad3061f991df7b431a"
  end

  depends_on "go" => :build

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https:github.comyorukotsuperfilepull837
  patch do
    url "https:github.comyorukotsuperfilecommit50a4f662f3cea8ca1cad685a89f5dc2282da5d92.patch?full_index=1"
    sha256 "959fb00c6b3491ac68ca21214139da9415f63f9a47ae44cc70ed9e3e3ce1adea"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}spf -v")
  end
end