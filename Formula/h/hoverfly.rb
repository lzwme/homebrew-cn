class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https:hoverfly.io"
  url "https:github.comSpectoLabshoverflyarchiverefstagsv1.10.5.tar.gz"
  sha256 "38639779eda33b8924e23a8640c9b07821795bf7d0c5defd5a02614e60ace550"
  license "Apache-2.0"
  head "https:github.comSpectoLabshoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b973a70738dd138e39d7c2783b54ee78f7bfb2d0c25cd38990952b8c97e69f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b973a70738dd138e39d7c2783b54ee78f7bfb2d0c25cd38990952b8c97e69f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b973a70738dd138e39d7c2783b54ee78f7bfb2d0c25cd38990952b8c97e69f5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "83cf86c1f4f43c5378b209f77041b9da4a4600b17d9a572921d0a2c50f84451c"
    sha256 cellar: :any_skip_relocation, ventura:       "83cf86c1f4f43c5378b209f77041b9da4a4600b17d9a572921d0a2c50f84451c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be7a87902bf85a41fb0481d82efbb40cad5088ba6a10aa1e54df1899053c574"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".corecmdhoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}hoverfly -version")
  end
end