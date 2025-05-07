class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https:github.comsimulotimmich-go"
  url "https:github.comsimulotimmich-goarchiverefstagsv0.26.1.tar.gz"
  sha256 "db8c5d73e3e1d00930be06cfb6b16afa95b3894f1836c97a12f94bd2baf61c5a"
  license "AGPL-3.0-only"
  head "https:github.comsimulotimmich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87e1155f5c29be3dde59edb988f105556a573221f748de5fb1821604cc413a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02d9763d159fa9e7cb140c28605505b4938462a305a19bb1d63287a31c7bcc04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfe5868fd5019825a573247ef27cac5fe31df652b0865e1770b84cb5754c466d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4f29548602e4f71d99e55bc8f832263916456a569503b3bbc6c92836ac4d297"
    sha256 cellar: :any_skip_relocation, ventura:       "ff5766ad7e805e09fa0f3715715029f39494d8333bce2bbfbe4668cbdc415e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "624a6242ddbe0aae6c7eca9292950d831ca18bfa316079d9b764870d91667170"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsimulotimmich-goapp.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}immich-go --server http:localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: error while calling the immich's ping API", output

    assert_match version.to_s, shell_output("#{bin}immich-go --version")
  end
end