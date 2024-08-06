class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.16.0.tar.gz"
  sha256 "32262dc2ca03ea04adb43085a8d6ef6c9d8da61d79d9645b0a8ad21e746a032e"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a9e019398eb2c2be64a27e67aa210dbaf9b8a0e229edcce6fdff0918c39534c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fbe8459600b4a8f0f5a0427d812830e140d889945f1dcc550db90db828fd605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9db131fd19fd9825210645379a52c31ff4930f6b2cb9fefc7d0f334dd7d7f33c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9aec6f1f42ae590851eedd94227fff8f88a52455d57a1867d16c33467e18306"
    sha256 cellar: :any_skip_relocation, ventura:        "0414ef73ecab50424766703d10c82214f5c41b44ab964e285e7da703552d4310"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc6b6f4bb8e7f3d5548aedf777a124f965266c32fd75d6165f009e0379e0d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "045c9af8807cb51ba8bb443ffcf7f951c92f3396b4d6c890f64ac6cb4879ec22"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end