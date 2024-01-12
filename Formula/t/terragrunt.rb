class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.54.15.tar.gz"
  sha256 "839f3f64f31108c2322005ff506535f1d8395a7e6dec1ed0bc6e813f4391b9fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30721c842b5ec1e99bfe049d132fa61fc634f54cf42e9f43edc82cd4733c1cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27989dea841f91e96a315bfb48c23356d640ea6fe7d7a77b372e546931ba7e54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32720396347367c615ed7402b9a8466c480c988b15707b8d178c03312060c947"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6edea913d46336d32bec567d6b8d3cbaac90f460de7f6e2a0f13204321528bb"
    sha256 cellar: :any_skip_relocation, ventura:        "f2e698ea4ced54fc20fdb56e990966e975c46a1a403776d7cf6d43f431d8dc82"
    sha256 cellar: :any_skip_relocation, monterey:       "bf1a1a1196bea17addd3ffd96d2e8c6ae95074586b3b7371fc83e45c9748c2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c05489448ae76f9cc9d1192ab0c076e883983d32c2d94aa1f6431a0042acce9"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end