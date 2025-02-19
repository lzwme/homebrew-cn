class Slumber < Formula
  desc "Terminal-based HTTPREST client"
  homepage "https:slumber.lucaspickering.me"
  url "https:github.comLucasPickeringslumberarchiverefstagsv3.0.0.tar.gz"
  sha256 "d64a03fbe394880ba076cb7bce5a43d7ef0811d9f469a62821301a8c70451feb"
  license "MIT"
  head "https:github.comLucasPickeringslumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76956c68336de67aca8163a2850eba9d7b275364d5beb8325d54b0b8ed02bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70cf9f7c836dc7f00e76f2be11bd00f2a34da05654894d093bb5628dc1893e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7d06c7b0aff91aab441266a9802c8b69b6dca8f7b024e8f3cda37c3f5982aec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b801778b547ee8467b43feddee7b6d796f97ee2fda86ddf51f51916f5b0bf76f"
    sha256 cellar: :any_skip_relocation, ventura:       "4a56f3db36773d762c9c6bd4895494f554176a18a835059b70eb8c99566a259e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef9b59fda62092caf5bb74f2256d688cd025122a76954a465315c7f7cf57dd5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slumber --version")

    system bin"slumber", "new"
    assert_match <<~YAML, (testpath"slumber.yml").read
      # For basic usage info, see:
      # https:slumber.lucaspickering.mebookgetting_started.html
      # For all collection options, see:
      # https:slumber.lucaspickering.mebookapirequest_collectionindex.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https:httpbin.org
    YAML
  end
end