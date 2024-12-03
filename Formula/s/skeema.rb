class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https:www.skeema.io"
  url "https:github.comskeemaskeemaarchiverefstagsv1.12.1.tar.gz"
  sha256 "22b7713921949bec8e6d23ea70f8460d6ff880e77e7fc0aefca3954b05086107"
  license "Apache-2.0"
  head "https:github.comskeemaskeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0234eb9e24ba34a94632359fb458da799beeb4c9173976cda3e35974e3379889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0234eb9e24ba34a94632359fb458da799beeb4c9173976cda3e35974e3379889"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0234eb9e24ba34a94632359fb458da799beeb4c9173976cda3e35974e3379889"
    sha256 cellar: :any_skip_relocation, sonoma:        "41da325d0aa3898d7643a88a1fb0ccc0f320e5da9b4830e5ad157f42e4dadb58"
    sha256 cellar: :any_skip_relocation, ventura:       "41da325d0aa3898d7643a88a1fb0ccc0f320e5da9b4830e5ad157f42e4dadb58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661a90a5d940126a04860f9117e2b27c323a2a01e6946a8e5c4d92788757f678"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}skeema --version")
  end
end