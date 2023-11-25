class Intercept < Formula
  desc "Static Application Security Testing (SAST) tool"
  homepage "https://intercept.cc"
  url "https://ghproxy.com/https://github.com/xfhg/intercept/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "3ca092dd54452fc2166b398410fd238f50e02e3313346bf820edc51132ee1324"
  license "AGPL-3.0-only"
  head "https://github.com/xfhg/intercept.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78b77aa50f17f1ddc911b094e861b00acf3a1f90b5e44d39c9f79e6eaf629464"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bec865964936d68afdb3e098db6e9dd037b9d0579b9947227109e0a6e62ad792"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08db43be777467587e537a3eeffebfd06bf8ac0f6d0ae9b13ed51a2cdee63c69"
    sha256 cellar: :any_skip_relocation, sonoma:         "2df85d16c23b7dfaf7cb3b070743bb3bc50720214684fdf61703d1c4dc41b261"
    sha256 cellar: :any_skip_relocation, ventura:        "1c029f7c22d64c8d08a819452e46da98662c045c4d3bef6df8afc3e9893db190"
    sha256 cellar: :any_skip_relocation, monterey:       "0e639c44513629aa47f69aef2f53405b27d3fe236878a0c8bc16a6c47935d5cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b149515f12b358df6ab91a69e41bab27133b4981023f0bcd2bd18fe5ab4d23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"intercept", "completion")

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples", testpath

    output = shell_output("#{bin}/intercept config -r")
    assert_match "Config clear", output

    output = shell_output("#{bin}/intercept config -a examples/policy/minimal.yaml")
    assert_match "New Config created", output
  end
end