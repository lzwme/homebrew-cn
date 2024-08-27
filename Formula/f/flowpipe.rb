class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https:flowpipe.io"
  url "https:github.comturbotflowpipearchiverefstagsv0.8.0.tar.gz"
  sha256 "97f96cd9086428563679b05818e798238a2490cf7c5edcb9f572c228a5d12247"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c845decb700c64657a85b3d6765ef0d028424228cd4a69ef297ddb229c735b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79f6c6a4c99d8dc8deef681b7eaf90f3b4497a54f59af9390363991062b3bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19c91cb7ff3ae2669fd2e2a696d5a26f784ca552b7696c1d0d640b48fdf4bb79"
    sha256 cellar: :any_skip_relocation, sonoma:         "6508348937ee8f2f5cf59c4dd90a1836306f5800ad6627c0003c8a6527ceeca0"
    sha256 cellar: :any_skip_relocation, ventura:        "7d8d970fac6dfb6eb4fcad00eaf2d3500e071837b5d3b0203c203a3e4ced093a"
    sha256 cellar: :any_skip_relocation, monterey:       "ba06a45e030405adf5e594ccef11b60932d0c9665433d6992067c786571f0687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02faebb31e7d00c808e0c63616f890caeda5ff03966f693dc6197395980fc4ec"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "uiform" do
      system "yarn", "install"
      system "yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}flowpipe -v")

    ret_status = OS.mac? ? 1 : 0
    output = shell_output(bin"flowpipe mod list 2>&1", ret_status)
    if OS.mac?
      assert_match "Error: could not create sample workspace", output
    else
      assert_match "No mods installed.", output
    end
  end
end