class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.22.0overarch.jar"
  sha256 "5477b96028be5547f4e71f8962b99be204d9276fad9f5343842e0e3df83ea1cd"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, ventura:        "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5496b305fcbe45b2c674b09f08fba230267ad02d57f3189e48d317d90fb257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05cb71bfe9c822b640683eb604da2bda023835fbfb984f4988480b2d473e876"
  end

  head do
    url "https:github.comsoulspace-orgoverarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "targetoverarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec"overarch.jar", "overarch"
  end

  test do
    (testpath"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end