class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.32.tar.gz"
  sha256 "baf955f9963c6d611cb69b20d0b36890e1bb6d0421868d21bb7f0b10ab7ac270"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48522eeaa5191d3908cb31ec6e11e3a4e6ce0d7375766da762ccb382270b0087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccfdc2dfa4257ae6bceff7ad7520076288929ea49dda58756e53783c7532551b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e854699a14350d196cb03fb78a5e34d1d2069dbb292116d8da6f81ccfb549d6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ae63337e9f374540a2194fb2532a92db26fd4c20f5851b59658fc66a842799e"
    sha256 cellar: :any_skip_relocation, ventura:        "35561a4e2c48420d0e5b6815a22b8eb229d25a9b49843dd8a3484f5f99c813ef"
    sha256 cellar: :any_skip_relocation, monterey:       "a2d4fd87f4d590a9585e3ba6654ac04cae7757e749b68e1c988284d9f047b88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e111d7860397b4f53f178a384cd55d0938649242cadf8f7da560ae22d8c3be5d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end