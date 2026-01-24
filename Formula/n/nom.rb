class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "df6b145ae813c5fd5b5aabd500fee25aaae71ef0fae966031b32418a3f97a067"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfecd576a94f838b095a8bbaadb43954149889eaaaa6102cdde15fa0aebcebf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c7fdb774a5c13572e405cb9842b3c00c820e03073e69d810aedcf6ae3a43ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3bf98b42f911ef30721abbba1bc68ee41e60db3890c46cc4ba27dc534ce00f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "33b78229354a5a97c4b7c7c76ea6f28e48029e04aee7034458c09b9f2f921dfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "340c808a0740d21f66aa7081b18a97ebf4c70d352b49f07e49d303af6b546ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18bcacb1688e4ce8026aad34a138c5b6a8da8f54340ba0fb3461522f4ac16306"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" # Required by `go-sqlite3`

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end