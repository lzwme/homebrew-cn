class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.88.tar.gz"
  sha256 "04b7dc2edf86cf6e917229f6d390bc4af08fc4ed39b87f434a578a973434ae19"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81653ebb2ff7c933a3ea26f09fef5fbf86b5ead58e5b418db4049ea072eb5481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81653ebb2ff7c933a3ea26f09fef5fbf86b5ead58e5b418db4049ea072eb5481"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81653ebb2ff7c933a3ea26f09fef5fbf86b5ead58e5b418db4049ea072eb5481"
    sha256 cellar: :any_skip_relocation, sonoma:        "05b08a8c54fcff0afcb4b9f08326d1e22b199114feffd86bdf19dc15da8a430b"
    sha256 cellar: :any_skip_relocation, ventura:       "05b08a8c54fcff0afcb4b9f08326d1e22b199114feffd86bdf19dc15da8a430b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7bcea91ccd3731179bf6a5de7c99f552aa7ee28dee4a2e391561bca10bc8c7f"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end