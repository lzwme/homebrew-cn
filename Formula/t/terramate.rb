class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.4.4.tar.gz"
  sha256 "0ea6e453d3da0281f0c6aab1142a9c980be2c819ab9c31e8b99ec0e69314b391"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59d7e9797a9ee3e5090dd8774230b432e26bbe4e062183c6266b6460dcd0b7d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a9f9d10ebd4713cb817851457390caf1acfdb7ef2fecc4d04ffeb7c6f54bb58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0286de6ddc827b4b6c773fa4b568762028fdb20238c5b363a3785392d953a62a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0b9801dae55957954285847edb6c5a0806f27f009ee4c95ed560824976c53a3"
    sha256 cellar: :any_skip_relocation, ventura:        "b3b94d8787b65df2401de460dbf76940c7f438cf9b090ba63f0ce650bc99295d"
    sha256 cellar: :any_skip_relocation, monterey:       "1136230e958136a10c1e2096be2ff4c718606b978d38e9640664caa54daab236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b18176be8aae76bf2849d221ecd1501c37d5e0fc606d68942f8e553dba38eb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end