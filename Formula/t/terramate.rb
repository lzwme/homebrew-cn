class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.9.3.tar.gz"
  sha256 "98e7bd6b087e1334c9a279b1628413967f3782cfe27b385acc4b18b94b4e5d8b"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977fc868e1ab9890c23ddfd298c4835986c9dec23371a950a686491370c0bf13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cab29ba486812e4ab4565461e2d26d08f25c34686d24171c9f8e380e736a7c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84a5476194efa30162dc9949ba9cf9b34851b133cbb1af9677718d0ecf02e04"
    sha256 cellar: :any_skip_relocation, sonoma:         "756e10802134b24a0d761ace70a5fe4e6e7d5f461c9a04051ec27b9c159b8aee"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a2f01bc1043dbbd1a7b388b3162bf53523132af9b72abb77451bd2acf3245a"
    sha256 cellar: :any_skip_relocation, monterey:       "a58171ac84eb63a9bea4a959e70454bdb0fe0934f58dfc0d6bca7f4b529d05e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddac81d90cb20971e29ce0254d2ee683ff0e197f4ec139f602c3ed6cfe1a3c6"
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