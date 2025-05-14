class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.5.12.tar.gz"
  sha256 "fa9dbd296fddde75922459f6808f866390475714d220f783af124889a71705be"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61a88a4458cd8d77bba2ade624bc1372bcb962acf2b603a440d14257604f6e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b70a0fdbfd57a89f00472154b6356e4646e10661de85062b11cc3a056c918eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82e51377aaf1ccc282e5bad98458cf414694f98280fb3a5bae5f95071af63d29"
    sha256 cellar: :any_skip_relocation, sonoma:        "420d0238bbe5f3fb0d35a13b0b242407cbbe911c93f9bd67132799fec67037a6"
    sha256 cellar: :any_skip_relocation, ventura:       "e43d06f4796829a426e3c7e6630f8da6a4773a97b3c42f019dee7d1660d6c973"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a533afe0bad172e5f65381d0e56fc241e79b341353ea74a52ec25093532037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b663a20648f24504d7ef3c466de7019490379a46250df6266f29de12529c70c"
  end

  depends_on "rust" => :build

  def install
    rm ".cargoconfig.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utilslinkage"

    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")
  end
end