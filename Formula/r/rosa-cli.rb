class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https:www.openshift.comproductsamazon-openshift"
  url "https:github.comopenshiftrosaarchiverefstagsv1.2.45.tar.gz"
  sha256 "6a335204824e359d2b89eee7f2f532f5f58c92d5a15f7e858c926cde144c8008"
  license "Apache-2.0"
  head "https:github.comopenshiftrosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ce9309bfbe6e16435b8599145380fac2c3224488c651658f47f9f02f706ec0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09a57e75d216a9ab72863519c1cbf0f2f248f8282c71b02a4103dd5df1f2f135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9de3f5a31fa5eecd07c6a5abdf99b0f90417f5b50ae76df2db3422d00406165d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1507df61259ff7e71fb881deb595482e2e990a63df81371e852597adf1200c38"
    sha256 cellar: :any_skip_relocation, ventura:       "a75e481fa8c080037beca62861e49062e491b12c1f7208414082994e2a116bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75645e0b8174de8ea95b78d0be9619b628592197ae7615151dd2ad671b62414b"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"rosa"), ".cmdrosa"

    generate_completions_from_executable(bin"rosa", "completion", base_name: "rosa")
  end

  test do
    output = shell_output("#{bin}rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}rosa version")
  end
end