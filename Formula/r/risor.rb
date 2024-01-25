class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https:risor.io"
  url "https:github.comrisor-iorisorarchiverefstagsv1.3.0.tar.gz"
  sha256 "e72fe34182fdb5dc27d86a63d50d5a9867606f3bd329506d951ca00f7342a278"
  license "Apache-2.0"
  head "https:github.comrisor-iorisor.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98516cbbbec34ee3504e2f04512ef657183ad54bb973788ea9bc747025ca8869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e6b2321eb2f16090730754a94eee216962e685490b40c20bbfceb02ad3c646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2499c5186944c01df705d4e8bfa3a5efa8758f420e31200cb60fe7fa7a5063c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb81e2bbf2050cedb02ef96e6cbce2b8b45324016d61007f08f279f47f80405e"
    sha256 cellar: :any_skip_relocation, ventura:        "8020605b6b8a5b81c49ade582a6d8c5c82290a979b0d9228ac22077af9a48f35"
    sha256 cellar: :any_skip_relocation, monterey:       "04de9178159aa6db159faf6649670f70a774eb205a143152643d85aee0cdab11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ece8f1b9ff764ce14b74b90063c50024bc24bca0ce1e4c450d29b683b5fbb0"
  end

  depends_on "go" => :build

  def install
    chdir "cmdrisor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}risor -c \"time.now()\"")
    assert_match(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}, output)
    assert_match version.to_s, shell_output("#{bin}risor version")
    assert_match "module(aws)", shell_output("#{bin}risor -c aws")
  end
end