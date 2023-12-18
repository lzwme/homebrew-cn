class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https:github.comalecthomaschroma"
  url "https:github.comalecthomaschromaarchiverefstagsv2.12.0.tar.gz"
  sha256 "56c546a834113493de95585d5034c3c58d42b4518787cff5450601f9d9d0e78d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, ventura:        "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906f60101b92ff9bce032b3583119f5afcf95e63e5a694291584354845d0bce4"
  end

  depends_on "go" => :build

  def install
    cd "cmdchroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end