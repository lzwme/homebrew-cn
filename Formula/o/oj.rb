class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.23.0.tar.gz"
  sha256 "077c5de0f9062d2c02b841d6291d461d56ed1f8839ffd6b50f91cb68f99ef327"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e042a1ddd891b683fc38b97d18a608c1d395e00555e0978bbd46519d8273315"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e042a1ddd891b683fc38b97d18a608c1d395e00555e0978bbd46519d8273315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e042a1ddd891b683fc38b97d18a608c1d395e00555e0978bbd46519d8273315"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ddb104c9ba734f68fdfbc8493ca89fd3b0be6296b33870baaf63139971f26c0"
    sha256 cellar: :any_skip_relocation, ventura:        "4ddb104c9ba734f68fdfbc8493ca89fd3b0be6296b33870baaf63139971f26c0"
    sha256 cellar: :any_skip_relocation, monterey:       "4ddb104c9ba734f68fdfbc8493ca89fd3b0be6296b33870baaf63139971f26c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72c00edb933f1c88b0e6cfe84638395a7138e49bf97663e73f2a30ea0b06a33"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end