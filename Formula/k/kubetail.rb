class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.2.0.tar.gz"
  sha256 "34e8bb01a2d062fdf0ec5847b926b8726c9674405378a40759f7331588328f9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da96803abaedea0f5674e77ffcf59b4806d307aad724d3283a05f2b2db2c05f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b8896da311d24b752960ee3469c7fefdcd90bfe7973fa31af4eadaa0c966c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3aecd527ae12c9d866574c8e09a500994cbd3efa2f4475248867db6fdc0a750f"
    sha256 cellar: :any_skip_relocation, sonoma:        "743c72067fea8f4ccfc827af52f08fca95c9fa624a75adb676bbc1d3596efc47"
    sha256 cellar: :any_skip_relocation, ventura:       "2b6b76a4743a303e599ccfa509a4c494a9d1e9e31d9568802e0e1fa2975c5dd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6553d600e78a88d6c3138e15759a6fe39e0ef6e695bf356488fb468c0c3b938"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end