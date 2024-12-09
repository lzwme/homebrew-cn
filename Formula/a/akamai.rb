class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https:github.comakamaicli"
  url "https:github.comakamaicliarchiverefstagsv1.6.0.tar.gz"
  sha256 "dede02e8809659f752415e55e5d1a42134d1c6f131dd2cd7b02ed91532848b61"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb62f539efcfbdf1d97670325d7de4ddd943299a057fbe1f25ade6faac568565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb62f539efcfbdf1d97670325d7de4ddd943299a057fbe1f25ade6faac568565"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb62f539efcfbdf1d97670325d7de4ddd943299a057fbe1f25ade6faac568565"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bdf2ab67fd7687bbda07711da9fd36afd50f23783e46e5d8386252d5fe90c26"
    sha256 cellar: :any_skip_relocation, ventura:       "8bdf2ab67fd7687bbda07711da9fd36afd50f23783e46e5d8386252d5fe90c26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de49b9102884029167dc753ecdc0894c81a7067a283893cb07a1971ce164a23"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", "-tags", "noautoupgrade nofirstrun", *std_go_args(ldflags: "-s -w"), ".cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}akamai install diagnostics")
    system bin"akamai", "uninstall", "diagnostics"
  end
end