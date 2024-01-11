class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https:github.comAzureazure-storage-azcopy"
  url "https:github.comAzureazure-storage-azcopyarchiverefstagsv10.22.2.tar.gz"
  sha256 "6d563f45bdd60d988fa69acea69cabece3080e0016a9903d2f74e95e7345e82e"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b876cb260d485149316cde0917771ce8005bd8f2486c7db8f3de589ecbdb38b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d58cd4c5392200adfba048ed4269d82d1871f1d44755ed66a2b1e6b47badaa6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a78aa612b68afba61d8b676547173d9bf8e46f75c7c8131d13258a7d5805265"
    sha256 cellar: :any_skip_relocation, sonoma:         "6adcd2436d671bd848c68554f9534a68308b6221ed1498341c61a8d1196fb68f"
    sha256 cellar: :any_skip_relocation, ventura:        "08b8e5658c04058f7a6c6279644d8fac5c87ce4880de7602f635f325d1297fe5"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d4445bc933f122f0c87506ef53088f9c7df0458de89d0e2b62cd747e56171c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804d7f83d9ee00259e4467879604ee945755ea3d9ca3a71912b36d8518bceea2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}azcopy list https:storageaccountname.blob.core.windows.netcontainername", 1)
  end
end