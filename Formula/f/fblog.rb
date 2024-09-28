class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https:github.combrocodefblog"
  url "https:github.combrocodefblogarchiverefstagsv4.12.0.tar.gz"
  sha256 "7033d56393fc95535839d232ad380c017945210c354f9040150c394c4728bb90"
  license "WTFPL"
  head "https:github.combrocodefblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e770797ed78cfd233776299ba4edd67c9b3fd2e197ac8e2047415df4f857a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1db408cea0ecad8cabccd49f0f4b7a3d3ae99aec163340e405d57bf963d1d37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c98c817c5cd2d995e98a32c55dbeaa3190f71197c19ccd4336b17847839d3585"
    sha256 cellar: :any_skip_relocation, sonoma:        "1346b8e5793f8e75d257051df1cce8fbbcd0f0628b6009ee6ea09f371e21f601"
    sha256 cellar: :any_skip_relocation, ventura:       "d5f522e6a1b86ebba7dd5a1bf647e1650e0feaccd2f3db1d7294a56cbb333e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28499b9c4489f9c04ffa1b48b1aebf38355ba27994d8df6dd33349b839b85bee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}fblog #{pkgshare"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end