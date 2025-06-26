class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https:github.commongodbkingfisher"
  url "https:github.commongodbkingfisherarchiverefstagsv1.12.0.tar.gz"
  sha256 "654b005b8163cf1626426c66b233e51583f6eb2b1287dd5766e240539a38f9cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8128485020e1eda98cbf53e6f516c29dacf0a829b415eacfcfc025bc99a072ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2acdc53e6571e2798e874129806518ad35702de344acdeeae9868a5dbdcd9601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ef139a9f2fd4619cf6cdd47843c94103b6049eaa2d3d6b83782b72a1903216d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b67ae7877416d37eb529f4d64280ef6a612c2c926438c543fbfb38082fbc44d6"
    sha256 cellar: :any_skip_relocation, ventura:       "a954ae07f8e3b7c84e7293790b60e8cbace329c64cbf9a135a8b928cfda6f123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54c23387a826accd832e39927b3b72c25ce86afbe7d82d7a88e6863cbfe42d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a028b38c2b5f8b41c5fcd3adf60075574c9af97c5bf21c3cd67903a857bb046f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kingfisher --version")

    output = shell_output(bin"kingfisher scan --git-url https:github.comhomebrew.github")
    assert_match "|Findings....................: 0", output
  end
end